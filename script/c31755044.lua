--十二獣ヴァイパー
--Juunishishi Viper
--Scripted by Eerie Code
function c31755044.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31755044,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c31755044.mcost)
	e1:SetTarget(c31755044.mtg)
	e1:SetOperation(c31755044.mop)
	c:RegisterEffect(e1)
	--get effect
	if not c31755044.global_check then
		c31755044.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c31755044.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c31755044.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(31755044)==0 end
	c:RegisterFlagEffect(31755044,RESET_CHAIN,0,1)
end
function c31755044.mfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_BEASTWARRIOR)
end
function c31755044.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(31755044)==0 end
	c:RegisterFlagEffect(31755044,RESET_CHAIN,0,1)
end
function c31755044.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c31755044.mfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31755044.mfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c31755044.mfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c31755044.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c31755044.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) and tc:GetOriginalRace()==RACE_BEASTWARRIOR
			and tc:GetFlagEffect(31755044)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCategory(CATEGORY_REMOVE)
			e1:SetDescription(aux.Stringid(31755044,1))
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_BATTLED)
			e1:SetCondition(c31755044.rmcon)
			e1:SetTarget(c31755044.rmtg)
			e1:SetOperation(c31755044.rmop)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(31755044,0,0,1)
		end
		tc=eg:GetNext()
	end
end
function c31755044.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,31755044)
end
function c31755044.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local a=Duel.GetAttacker()
		if a==c then a=Duel.GetAttackTarget() end
		e:SetLabelObject(a)
		return a
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c31755044.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
