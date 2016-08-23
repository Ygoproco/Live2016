--墓荒らし
function c61705417.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c61705417.target)
	e1:SetOperation(c61705417.activate)
	c:RegisterEffect(e1)
end
function c61705417.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c61705417.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c61705417.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c61705417.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c61705417.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c61705417.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		tc:RegisterFlagEffect(61705417,RESET_EVENT+0x5c0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c61705417.tgcon)
		e1:SetOperation(c61705417.tgop)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+0x5c0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EFFECT_SEND_REPLACE)
		e2:SetTarget(c61705417.reptg)
		e2:SetReset(RESET_EVENT+0x5c0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetCondition(c61705417.actcon)
		e3:SetOperation(c61705417.actop)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetCondition(c61705417.damcon)
		e4:SetOperation(c61705417.damop)
		e4:SetLabelObject(tc)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetCode(EFFECT_SEND_REPLACE)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e5:SetTarget(c61705417.reptg2)
		e5:SetOperation(c61705417.repop2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(61705419,0,0,1)
	end
end
function c61705417.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetControler()~=tc:GetOwner() and tc:GetFlagEffect(61705417)~=0
end
function c61705417.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c61705417.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_COST) and c:GetControler()~=c:GetOwner() end
	c:ResetFlagEffect(61705418)
	Duel.Damage(c:GetControler(),2000,REASON_EFFECT)
	return false
end
function c61705417.actcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler()==e:GetLabelObject() and re:GetHandler():GetFlagEffect(61705417)~=0
end
function c61705417.actop(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(61705418,RESET_CHAIN,0,1)
	e:Reset()
end
function c61705417.damcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler()==e:GetLabelObject() and re:GetHandler():GetFlagEffect(61705418)~=0
end
function c61705417.damop(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():ResetFlagEffect(61705418)
	Duel.Damage(tp,2000,REASON_EFFECT)
	e:Reset()
end
function c61705417.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(61705419)>0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c61705417.repop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(61705419)
	Duel.SendtoGrave(e:GetHandler(),e:GetHandler():GetReason(),e:GetHandler():GetOwner())
end

