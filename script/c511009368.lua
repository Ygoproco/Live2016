--Performapal Gatling Ghoul
--Fixed by TheOnePharaoh
function c511009368.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c511009368.mat_fil,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9f),true)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29343734,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511009368.damcon)
	e1:SetTarget(c511009368.damtg)
	e1:SetOperation(c511009368.damop)
	c:RegisterEffect(e1)
	--Material Check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c511010239.matregcon)
	e2:SetOperation(c511010239.matregop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c511009368.condition)
	e3:SetTarget(c511009368.target)
	e3:SetOperation(c511009368.operation)
	c:RegisterEffect(e3)
end
function c511009368.mat_fil(c)
	local attr=c:IsAttribute(ATTRIBUTE_DARK)
	if Card.IsFusionAttribute then
		attr=c:IsFusionAttribute(ATTRIBUTE_DARK)
	end
	return attr and c:GetLevel()>=5
end
function c511009368.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c511009368.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,0xc,0xc)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c511009368.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(tp,0xc,0xc)
	Duel.Damage(p,ct*200,REASON_EFFECT)
end
function c511009368.matfilter(c)
	return c:IsType(TYPE_PENDULUM) 
end
function c511010239.matregcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and e:GetHandler():GetMaterial():IsExists(c511009368.matfilter,1,nil)
end
function c511010239.matregop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		c:RegisterFlagEffect(511009368,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c511009368.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(511009368)~=0 end
end
function c511009368.filter(c)
	return c:IsFaceup() 
end
function c511009368.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c511009368.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009368.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009368.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c511009368.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
