--十二獣ヴァイパー
--Juunishishi Viper
--Scripted by Eerie Code
function c7516.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7516,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7516.mtg)
	e1:SetOperation(c7516.mop)
	c:RegisterEffect(e1)
	--get effect
	if not c7516.global_check then
		c7516.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c7516.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c7516.mfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_BEASTWARRIOR)
end
function c7516.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7516.mfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7516.mfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c7516.mfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7516.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c7516.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) and tc:GetOriginalRace()==RACE_BEASTWARRIOR
			and tc:GetFlagEffect(7516)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCategory(CATEGORY_REMOVE)
			e1:SetDescription(aux.Stringid(7516,1))
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_BATTLED)
			e1:SetCondition(c7516.rmcon)
			e1:SetTarget(c7516.rmtg)
			e1:SetOperation(c7516.rmop)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(7516,0,0,1)
		end
		tc=eg:GetNext()
	end
end
function c7516.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,7516)
end
function c7516.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local a=Duel.GetAttacker()
		if a==c then a=Duel.GetAttackTarget() end
		e:SetLabelObject(a)
		return a
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c7516.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
